# SVG Architect

SVG をブラウザ内で構築・編集可能にするツールの開発プロジェクトです。
原則としてサーバレスで、クライアントサイド JavaScript のみで動作させています。

## 機能

* ファイル入出力
    * SVG ファイルの読み込み
    * SVG ファイルのダウンロード保存(一部動作しないブラウザあり)
* 作成
    * 図形(簡易)
        * 矩形(rect)
        * 円(circle)
        * テキスト(text)
        * 画像(image)
    * グループ(簡易)
    * グラデーション(linearGradient, radialGradient)
* 編集
    * インスペクタ
        * 属性編集
        * InnerText の編集
        * transform の追加・編集
            * 移動(translate)
            * 回転(rotate)
            * スケーリング(scale)

### 対応予定

* 作成
    * 図形追加時に入力フォームを表示
    * パス(path)、線(line)、楕円(ellipse)、折れ線(polyline)、多角形(polygon)の追加
    * 定義(defs)の追加
    * 参照(use)の追加
    * パターンの定義
    * フィルタ
* 編集
    * 選択してグループ化
    * グループ解除
    * 要素の削除
    * 順序の変更
    * グラデーション・ストップの追加と削除
* その他
    * アニメーション
    * JavaScript の埋め込み