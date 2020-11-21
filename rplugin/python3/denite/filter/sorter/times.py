from denite.base.filter import Base
from denite.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter/times'
        self.description = 'sorter for playing time'

    def filter(self, context: UserContext) -> Candidates:
        return sorted(context['candidates'], key=lambda a: int(float(a['ptime']) * 1000))
