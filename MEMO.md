# 学習メモ
## ボタンのタイトルを遷移元から直接値を書き換える形で実装しようとした際にうまく行かなかった件
Xibで定義されている各種ラベルなどはXibのカスタムクラスの`viewDidLoad`が呼ばれた段階でインスタンスが生成されるため，遷移元で直接遷移先のインスタンスの
パラメータをいじっても値がセットされない。

## 画面のリロードに`viewWillAppear`内で`loadView()`, `viewDidLoad()`を呼んでいた件について
`viewDidLoad()`はライフサイクル内で一度しか呼ばれないべきであるので，呼ばないようにする。

## ある画面で固定な値を使用したい時，かつ前の画面から渡される場合
イニシャライザを使用する。それによって定数で定義することができる。

## Force unwrapについて
自分で手打ちしたURLなどが原因でパースに失敗したなどでnilになる場合などは使い，毎回可変な値で結果がことなりそうな場合はForce unwrapを使用するのではなく，
`guard let` で捕捉してelseのなかで`fatalError`で該当の箇所に関するメッセージを出力する。

## Xib, storyboardについて
### 画面がStoryboardのみで作られている場合
 iOS 10 までの慣習。当時はStoryboardでしか現在Xibでもできるようなことができなかった。
 
### storyboardを使用する場合
#### 良い点
複数の画面を１つのファイルで扱いたい時。画面遷移なども見た目でわかるため，その点，良い。
#### 悪い点
イニシャライザを使用することができない。複数人で開発する際にコンフリクトが多発する。

## UIViewControllerのイニシャライザについて
`init()`を定義すると，同時に`init(coder aDecoder: NSCoder)`を定義しなくてはいけないが，
`init(coder aDecoder: NSCoder)`についてはstoryboardを使用した時に呼ばれるイニシャライザ。
xibを使用している時には`init(coder aDecoder: NSCoder)`は呼ばれないはずなので，万が一呼ばれた際には`fatalError`などで例外をだす。

## Google Calendar APIでの操作について
### 参考
- [Firebase - iOS で Google ログインを使用して認証する](https://firebase.google.com/docs/auth/ios/google-signin?hl=ja)
- [edurd/GoogleCalendarSwift](https://github.com/edurd/GoogleCalendarSwift)

### 参考
Google sign-in button での認証処理を行うためには，GIDSignInUIDelegateとGIDSignInDelegateを準拠しなくてはいけない。
