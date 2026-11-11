# plumOS-pixel2 への適用（2026-11-11）

[v0.1.0のPixel2専用パッケージ](../pixel2/README_JA.md)は、ここで確認した回転版の最終パスを相対パスのプリセットとともに収録する。一般的な機種・OSには[通常版](../shader-only/README_JA.md)を案内する。下記の実機配置パスと設定はPixel2固有の記録。

## 現在の実機設定

- 対象は plumOS-pixel2。RetroArch 1.22.2、Ozone メニュー選択時の GL 描画、Gambatte で確認した。
- シェーダー本体は `/mnt/plumos/config/shaders/mgb-native-lcd/` に配置。
- `/mnt/plumos/config/retroarch/config/Gambatte/GB.glslp` は、GB フォルダのゲームだけに適用する 2 パスのプリセット。GBC や他システムには適用しない。
- 同じ場所の `GB.cfg` はシェーダー有効、適用遅延 2 秒、回転値 0、全画面アスペクト、整数スケールを設定する。起動スクリプトの共通設定を変更しないための GB 専用設定である。
- RGB 利得は Pocket Block で実機比較して採用した `(0.82, 0.83, 0.71)` のまま。

Pixel2 の GL シェーダー経路では、480×640 の物理表示面へ FBO の画像が横向きで描かれた。通常の RetroArch 回転値だけでは正立しなかったため、最終パスの頂点座標を `gl_Position = (p.y, -0.833333 p.x, p.z, p.w)` とした。係数 0.833333 は、480×640 の面に回転した 160×144 の画面を約480×533で収める値である。Pixel2 専用の `mgb-grain-fade-draw-pixel2.glsl` だけにこの変更を入れ、元の Pocket Block 用シェーダーは変更していない。

起動時に即時適用すると画面が黒いままになった。`video_shader_delay = "2"` で解消した。整数スケールを有効にすると、実機で目立ったモアレが消えた。ユーザーは FE からポケモン緑を再起動し、最初から正立して正常に表示されることを確認した。DRM scanout の最終取得画像は `deployment/pixel2/pokemon-final-scanout.png`。RetroArch のログには GB プリセットの読み込み、2 パスの GLSL リンク、feedback FBO の作成、適用が記録された。

静止版を使った診断プリセットや途中の回転試験ファイルは、本番の `GB.glslp` から参照しない。残像の見え方、音声、入力、終了と再起動の全経路、および性能は Pixel2 上で別途定量評価していない。

## Mac版RetroArchでの比較

Mac版 RetroArch 1.22.2 では、元の `mgb-grain-fade.glslp` を変更せず、GL 描画でポケモン緑を起動した。2 パスの GLSL プログラムがリンクされ、ゲーム映像も正立して正常に表示された。GPU スクリーンショットは `deployment/mac/pokemon-green-gl-original-shader.png`。Mac の既存設定は Metal 描画だったため、テストには別の一時設定ファイルで GL を選び、元の設定ファイルを変更しなかった。
