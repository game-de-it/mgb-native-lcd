# MGB Native LCD plumOS-pixel2専用版

[English](README.md) | **日本語**

これは**plumOS-pixel2専用**のMGB Native LCDです。他の一般的な機種・OSでは[通常版](https://github.com/game-de-it/mgb-native-lcd/releases/tag/v0.1.0)を使ってください。Pixel2のGL/FBO出力では480×640のパネルへ横向きに描かれたため、最終パスの頂点座標だけを回転しています。液晶の色、格子、粒、影、残像の式は通常版と共通です。

## ファイル

- `mgb-grain-fade-pixel2.glslp`：相対パスで両パスを参照するPixel2専用プリセット。
- `mgb-grain-fade-track.glsl`：通常版と同一の時間応答パス。
- `mgb-grain-fade-draw-pixel2.glsl`：Pixel2用の頂点変換を加えた最終パス。
- `GB.cfg.example`：実機のGB起動時に必要だった設定例。自動インストーラーではありません。

## plumOS-pixel2への導入

1. プリセットと2つの`.glsl`を同じディレクトリへ置きます。実機で確認した配置先は `/mnt/plumos/config/shaders/mgb-native-lcd/` です。
2. GL/OpenGL系の映像ドライバーと160×144・4階調のGB映像を使い、コアのDMGパレット・カラー化を解除します。
3. **設定 → ビデオ → スケーリング → 整数スケールをONにします。** 設定キーは `video_scale_integer = "true"`。Pixel2で確認された格子のモアレを避けるための必須条件です。
4. RAのシェーダーメニューから `mgb-grain-fade-pixel2.glslp` を読み込みます。Pixel2では通常版プリセットを選ばないでください。
5. GBの自動起動に使う場合は既存のGambatte/GB上書き設定をバックアップし、適用中のシェーダーをGBコンテンツディレクトリ用プリセットとして保存します。`GB.cfg.example` の必要な行をGB専用設定へ取り込んでください。実機では `video_shader_delay = "2"` により起動時の黒画面を防ぎ、`video_rotation = "0"` として回転をシェーダー側に任せました。
6. FEへ戻ってGBを再起動し、最初から正立・整数倍・モアレなしで表示されることを確認します。GBCや他システムにこのGB専用プリセットが適用されていないことも確認してください。

16項目の説明は同梱の[パラメーター解説](PARAMETERS_JA.md)を参照してください。[英語版](PARAMETERS.md)もあります。Pixel2の回転は固定で、調整項目には含まれません。

設定例の `aspect_ratio_index = "24"` は、実機で使った全画面設定です。既存の上書き設定を丸ごと置き換えず、必要な行を取り込んでください。整数スケールと適用遅延はシェーダー単体では設定できません。

## 対象範囲と制限

回転は確認済みplumOS-pixel2のRetroArch GL/FBO経路に対する修正です。Pocket Block、macOS、plumOS-MF、ANBERNIC stockOSなど通常の正立出力には適用しません。Pixel2ではFEからの再起動後に正立表示を目視確認しましたが、残像の動き、性能、音声・入力・終了の全経路は個別に測定していません。[配備記録](https://github.com/game-de-it/mgb-native-lcd/blob/main/docs/pixel2-deployment-ja.md)も参照してください。

## ライセンス

シェーダーのソースと本プロジェクトで作成した文書は[MITライセンス](LICENSE)、© 2026 game-de-itです。
