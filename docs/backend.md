# Test

here a quick script that can be run from a python console by running `cd lambda/readings && pipenv run python` to check that data is fetched correctly

```python
from readings.utils.sqlalchemy import get_session, row2dict
from readings.models import Device, RawData
from readings.utils.etl import transform_imports
session = get_session()
rows = session.query(RawData).order_by(RawData.glb_tsp.desc())[:5]
row2dict(rows[1])
transform_imports(row2dict(rows[1]))
```
