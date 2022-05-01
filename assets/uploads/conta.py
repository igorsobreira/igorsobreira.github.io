
from datetime import datetime

class Conta(object):
    '''
    >>> c = Conta(100.00)
    >>> print c.saldo
    100.0
    >>> isinstance(c._ultimo_acesso, datetime)
    True
    >>> c.saldo = 200
    >>> print c.saldo
    200
    >>> c.depositar(50)
    True
    >>> c.depositar(-200)
    False
    >>> c.saldo
    250
    
    '''
    def __init__(self, saldo = 0.0):
        self._saldo = saldo
        self._ultimo_acesso = None
    
    def depositar(self, valor):
        if valor > 0:
            self._saldo += valor
            return True
        return False

    def _get_saldo(self):
        self._ultimo_acesso = datetime.now()
        return self._saldo

    def _set_saldo(self, novo_saldo):
    	if novo_saldo > 0:
    		self._saldo = novo_saldo

    saldo = property(_get_saldo, _set_saldo)

if __name__ == '__main__':
    import doctest
    doctest.testmod()