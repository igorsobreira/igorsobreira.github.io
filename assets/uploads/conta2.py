
from datetime import datetime

class Conta(object):
    '''
    >>> c = Conta(100.00)
    >>> c.saldo
    100.0
    >>> isinstance(c._ultimo_acesso, datetime)
    True
    >>> c.saldo = 200
    >>> c.saldo
    200
    >>> c.depositar(30)
    True
    >>> c.depositar(-20)
    False
    >>> c.saldo
    230
    >>> del c.saldo
    removendo o atributo saldo
    >>> c.saldo
    Traceback (most recent call last):
    ...
    AttributeError: 'Conta' object has no attribute '_saldo'
    
    '''
    def __init__(self, saldo = 0.0):
        self._saldo = saldo
        self._ultimo_acesso = None
    
    def depositar(self, valor):
        if valor > 0:
            self._saldo += valor
            return True
        return False
    
    @property
    def saldo(self):
        self._ultimo_acesso = datetime.now()
        return self._saldo
    
    @saldo.setter
    def saldo(self, novo_saldo):
    	if novo_saldo > 0:
    		self._saldo = novo_saldo

    @saldo.deleter
    def saldo(self):
        print('removendo o atributo saldo')
        del self._saldo

if __name__ == '__main__':
    import doctest
    doctest.testmod()