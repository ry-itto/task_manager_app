# TODOアプリ

## 最低目標
- CRUD処理が滞りなくできる
- 完了状態かどうかがわかる

## 目標
- 期日に指定した日付が自動的にGoogle Calendarへ登録される
- UIがいい感じになってる
- チェックボックスで完了状態か判断する

## 進行状況

## 疑問点
### 編集画面へ遷移する際に，RootのViewControllerからRegisterViewControllerの各種TextFieldの値をセットして遷移後の値をセットしようとしたが，まずうまくいかなかった。
#### 上手くいった方法
viewWillAppear内でview自体のリロードをかける(loadView(), viewDidload()を実行)
#### 疑問
なぜリロードの処理をかける必要があるのか？

### 編集画面，登録画面のViewを同じものにしたかったため，RegisterViewControllerをインスタンス化した後にButtonのTitleをセットしようとしたが，上手くいかない。

## 要変更箇所
- 登録，編集画面のViewが２つの役割を持っているのにRegisterの名前しか持っていないため，変える必要がある
- チェックボックスのアイコン

## 期日
2019 / 1 / 15

