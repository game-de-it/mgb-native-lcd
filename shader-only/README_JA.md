# MGB Native LCD シェーダー単体

[English](README.md) | **日本語**

これは一般的な対応機種・OS向けの**通常版・既定の配布物**です。リリースファイル名は `MGB-Native-LCD-Standard-v0.1.0.zip`。plumOS-pixel2の回転修正は[別配布の専用版](https://github.com/game-de-it/mgb-native-lcd/releases/tag/v0.1.0)にあります。RetroArch、GBコア、ゲームファイル、端末別の設定は含みません。

## 導入方法

1. `mgb-grain-fade.glslp`、`mgb-grain-fade-track.glsl`、`mgb-grain-fade-draw.glsl` を元の名前のまま同じ場所に置き、RAのシェーダーブラウザから見える場所へコピーします。
2. GLSLに対応するGL/OpenGL系の映像ドライバーを選び、変更時はRAを再起動します。
3. **設定 → ビデオ → スケーリング → 整数スケールをONにします。** 格子を正しく表示するための必須条件です。設定キーは `video_scale_integer = "true"`。プリセットはこの設定を変更できません。上書き設定で戻されていないかも確認してください。
4. GBコアやFEのDMGパレット・カラー化を解除し、160×144・4階調のGB映像を使います。
5. **クイックメニュー → シェーダー → プリセットを読み込む**で `mgb-grain-fade.glslp` を選んで有効にします。再起動後にも実際に適用されたプリセットを確認します。

16項目の説明は同梱の[パラメーター解説](PARAMETERS_JA.md)を参照してください。[英語版](PARAMETERS.md)もあります。

## 他の端末で見え方が異なる理由

- Pocket Blockの基準表示は160×144から800×720への正確な5倍です。他の整数倍率では格子間隔は均一でも、細い隙間や粒が変わって見えます。非整数倍率はモアレの原因になります。
- RGB利得はPocket Blockの比較環境で調整しました。別のパネルや輝度では色味が変わります。
- 2パス版にはGLSLとフィードバックバッファが必要です。対応しないドライバーでは動作しません。
- 通常版に回転処理はありません。確認済みplumOS-pixel2のGL/FBO経路だけ、別配布のPixel2版を使います。
- 古いゲーム別プリセットが他のシェーダー設定に優先する場合があります。

エラーなく描画できることと、MGB実機に近い見え方になることは別です。モデルと実機記録は[プロジェクトREADME](https://github.com/game-de-it/mgb-native-lcd/blob/main/README_JA.md)を参照してください。

## ライセンス

シェーダーのソースと本プロジェクトで作成した文書は[MITライセンス](LICENSE)、© 2026 game-de-itです。
