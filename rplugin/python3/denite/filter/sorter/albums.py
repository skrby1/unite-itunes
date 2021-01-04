from denite.base.filter import Base
from denite.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter/albums'
        self.description = 'sort candidates for name and album'

    def filter(self, context: UserContext) -> Candidates:
        return sorted(sorted(sorted(sorted(context['candidates'],
            key=lambda a: str(a['sartist']).lower()),
            key=lambda b: int(b['tkno'])),
            key=lambda c: int(c['discno'])),
            key=lambda d: str(d['album']).lower())
