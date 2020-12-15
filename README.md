# タスク管理アプリ
***
## テーブルスキーマ
***
### User
|  カラム名　　　　　  |  データ型  |
| ----------------- | -------- |
|  id               |  integer |
|  name             |  string  |
|  email 　　　　　　 |  string  |
|  password_digest  |  string  |

### Task
|  カラム名  |  データ型  |
| --------- | -------- |
|  id       |  integer |
|  title    |  string  |
|  content  |  text    |
|  user_id  |  bigint  |

### Label
|  カラム名  |  データ型  |
| --------- | -------- |
|  id       |  integer |
|  name     |  string  |

### Labeling
|  カラム名  |  データ型  |
| --------- | -------- |
|  id       |  integer |
|  task_id  |  bigint  |
|  label_id |  bigint  |
