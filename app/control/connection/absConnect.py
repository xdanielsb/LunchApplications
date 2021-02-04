from abc import ABCMeta, abstractmethod

class AbsConnect(metaclass=ABCMeta):

    @abstractmethod
    def get_db(self,username=None, password=None):
        pass

    @abstractmethod
    def query(self,query):
        pass
    
    @abstractmethod
    def execute(self,statement):
        pass
