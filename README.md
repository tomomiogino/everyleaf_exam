# タスク管理アプリ

## テーブルスキーマ

### User
|  カラム名　　　　　  |  データ型  |
| ----------------- | -------- |
|  id               |  integer |
|  name             |  string  |
|  email 　　　　　　 |  string  |
|  password_digest  |  string  |

### Task
|  カラム名   |  データ型  |
| ---------  | -------- |
|  id        |  integer |
|  title     |  string  |
|  content   |  text    |
|  deadline  |  datetime|
|  status    |  integer |
|  priority  |  integer |
|  user_id   |  bigint  |

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

## Herokuへのデプロイ手順
1. Herokuにログインする
```
$ heroku login
```
2. Herokuに新しいアプリケーションを作成
```
$ heroku create
```
3. Heroku buildpackを追加する(初回のみ)
```
$ heroku buildpacks:set heroku/ruby
$ heroku buildpacks:add --index 1 heroku/nodejs #必要に応じ
```
4. アセットプリコンパイルをする
```
$ rails assets:precompile RAILS_ENV=production
```
5. コミットする
```
git add -A
git commit -m "deploy to heroku"
```
6. remoteのherokuが正しい接続先になっているか確認
```
$ git remote -v
```
7. Herokuにデプロイ
```
$ git push heroku master
```
8. データベースの移行(マイグレーション)
```
$ heroku run rails db:migrate
```
