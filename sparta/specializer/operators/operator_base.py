# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

import abc
import warnings
from typing import Any, List, Dict, Optional, Type

import torch

from sparta.specializer.funtional import SparseCtxBase
from sparta.testing.utils import test_latency


class OperatorBase(torch.nn.Module):

    __base_class__: Type[torch.nn.Module] = None
    __sparse_func__: Type[torch.autograd.Function] = None

    def __init__(self, raw_module: torch.nn.Module):
        if type(raw_module) is not self.__base_class__:
            raise ValueError(f'expected a {self.__base_class__} module')
        super().__init__()
        self._raw_module = raw_module
        self._sparse_ctx: SparseCtxBase = None
        self._shape: Dict[str, int] = None
        self._mask: Dict[str, torch.Tensor] = None
        self.ready: bool = False

    @abc.abstractmethod
    def _read_sample_inputs(self, *args):
        '''Read missing shape value from sample inputs.'''

    def build(self, params: Dict[str, Any], sample_inputs: List[Any]):
        self._read_sample_inputs(*sample_inputs)
        self._sparse_ctx.set_shape(**self._shape)
        self._sparse_ctx.build(params, self._mask)
        self.ready = True

    @abc.abstractmethod
    def _sparse_forward(self, *args):
        '''Call sparse forward function with inputs and parameters.'''

    def forward(self, *args) -> torch.Tensor:
        '''Forward function. Calls the corresponding dense operator if not built.'''
        if self.ready:
            return self._sparse_forward(*args)
        else:
            warnings.warn('the sparse module is not compiled, using the dense module to forward')
            return self._raw_module.forward(*args)

    def get_search_space(self):
        return self._sparse_ctx.get_search_space()

    def test(
        self, params: Dict[str, Any], sample_inputs: List, sample_grad: Optional[torch.Tensor] = None,
        num_warmups: int = 10, num_iters: int = 10, backward_weight: float = 1
    ):
        self.build(params, sample_inputs)
        forward_latency = test_latency(
            func=self.forward,
            inputs=sample_inputs,
            num_warmups=num_warmups,
            num_iters=num_iters,
            cuda=True
        )
        latency = {'forward': forward_latency}
        if backward_weight > 0:
            output = self.forward(*sample_inputs)
            backward_latency = test_latency(
                func=output.backward,
                inputs=[sample_grad],
                num_warmups=num_warmups,
                num_iters=num_iters,
                cuda=True
            )
            latency['backward'] = backward_latency
        return latency
