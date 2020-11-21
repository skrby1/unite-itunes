from denite.base.filter import Base
from denite.util import Nvim, UserContext, Candidates

class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter/playlist'
        self.description = 'sorter for playlist tracks (do nothing)'

    def filter(self, context: UserContext) -> Candidates:
        return context['candidates']
