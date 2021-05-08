# liberte

ごく普通のウェブフレームワークです。

これまで使ってきた自作の[egalite](https://github.com/araipiyo/egalite)がコードが汚く、またRuby3.0対応していないため、それで新しいプロジェクトを書く気がしなくなったので、新しいのを作りました。使い方はわりと似てるかと思いますが、互換性は現在ありません。将来的に互換性を実現するためのモジュールを作るかもしれませんが、未定です。

Liberteの使い方はコードとapp_templateにあるサンプルを見てください。/lib/liberteにあるhandler.rbとcontroller.rbが中核なので、そこを読めばだいたいわかるとは思います。

# 起動するには

/app_template ディレクトリに移動して、ruby start_local.rbでWEBrickサーバでアプリが起動します。

/app_template ディレクトリに移動して、ruby console.rbでIRBコンソールが起動します。この中でデータベースにアクセスしたり、Mock HTTPアクセス(get等)が可能です。

IRBから_getと打つと実行時間を測定します。コード中に_profileという文を埋め込んでおくと、その箇所の実行時間も測定します。

起動時に必要な処理などはconfiguration.rbに書きます。

