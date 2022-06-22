#!/usr/bin/env python
# -*- coding: utf8 -*-
#
# Só uma demonstração de testes
import unittest

class Testing(unittest.TestCase):
    def test_vazio1(self):
        self.assertEqual(1,1)


if __name__ == '__main__':
    unittest.main()
