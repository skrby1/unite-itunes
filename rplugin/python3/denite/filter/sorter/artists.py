from denite.base.filter import Base
from denite.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter/artists'
        self.description = 'sorter for title and year)'

    def filter(self, context: UserContext) -> Candidates:
        return sorted(sorted(sorted(context['candidates'],
            key=lambda a: int(a['tkno'])),
            key=lambda b: str(b['album']).lower()),
            key=lambda c: str(c['sartist']).lower())
