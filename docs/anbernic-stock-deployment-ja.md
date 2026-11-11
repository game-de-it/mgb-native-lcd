# ANBERNIC stockOS 適用記録（2026-11-12）

対象は ANBERNIC stockOS。GB の実起動経路は
`/mnt/mod/ctrl/RA_launch.sh` から Gambatte を 32-bit RetroArch 1.22.0
（`/mnt/vendor/deep/retro/retroarch`）で動かすもの。GL/EGL/GLSL に対応する。

stockOS はゲーム起動ごとに `shaders.sh GB` を呼び、
`/mnt/vendor/deep/retro/config/global.glslp` を書き換える。そこで既存の
GB 専用カスタムシェーダー機構を使った。

- `/mnt/mmc/anbernic/custom/GB/config.cfg`:
  `shaderset=mgb-native-lcd/mgb-grain-fade.glslp`
- `/mnt/mmc/anbernic/custom/GB/mgb-native-lcd/`:
  採用済みの2パスプリセットと2つのGLSLファイル
- `/mnt/vendor/deep/retro/shaders/mgb-native-lcd/`:
  RAメニューから選択するための同一ファイル

初回の実機表示は他のOSより暗かった。シェーダーOFFの撮影で、
Gambatteの入力映像自体が濃い緑のDMG系パレットと確認できた。
`/mnt/vendor/deep/retro/config/Gambatte/GB.opt` の
`gambatte_gb_colorization` を `auto` から `disabled` に変更した。
変更後はユーザーがGBの正常表示を確認。撮影画像
`deployment/anbernic-stock/aretha-no-dmg.png` には格子、粒子、四辺の影が
出ている。入力色の調査画像は同ディレクトリの
`aretha-shader-off.png`。スクロール時の残像と性能は未評価。
整数スケールONも、この端末ではまだ個別に確認していない。正しい格子表示には
RA側で `video_scale_integer = "true"` を有効にし、実際の表示倍率を確認する必要がある。

変更前のGB設定、Gambatteオプション、stockOSのグローバルプリセットは
`/mnt/mmc/anbernic/custom/.mgb-backup-20261112/` に保管した。
stockOSの起動スクリプト、RetroArch本体、他機種の設定は変更していない。
