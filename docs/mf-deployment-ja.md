# plumOS-MF / MMF 適用記録（2026-11-12）

## plumOS-MF

MF の RetroArch 1.22.2 は Mali GPU、EGL/OpenGL ES 3.2、GLSL に対応する。
GB の標準起動プロファイルは Gambatte で、Ozone メニュー設定のためゲーム起動時に
GL ドライバーが選ばれる。現在の 2 パス版を変更せず、以下へ配置した。

- `plumos/config/retroarch/shaders/mgb-native-lcd/`:
  `mgb-grain-fade-track.glsl`、`mgb-grain-fade-draw.glsl`、
  RA メニューから選択できる `mgb-grain-fade.glslp`
- `plumos/config/retroarch/config/Gambatte/gb.glslp`:
  GB コンテンツフォルダ用プリセット。色利得は `(0.82, 0.83, 0.71)`。
- 同じ場所の `gb.cfg`: シェーダー有効、2 秒の適用遅延、整数スケール。
  GBC には適用しない。

MF の共有設定では `rgui_config_directory` と `video_shader_dir` が
`~/mnt/SDCARD/...` になっており、実際には `/root/mnt/SDCARD/...` と
解決されていた。このためコンテンツ別設定や RA メニューのシェーダー一覧が
見つからなかった。RA が終了した状態で共有設定
`plumos/config/retroarch/retroarch-mf.cfg` の2行を実際の SD カードパスへ
修正した。直後に GB を起動し、正常終了、プリセット適用、パスの保持を確認。
`plumos/bin/plumos-retroarch-launch` は元の版に戻しており、ハッシュは
`f749cb21497ea476e99980775cb53517d77aaa65831fec180cc941a6d5c61b08`。
実機バックアップは `plumos/backups/mgb-mf-shader-browser-20261112/`。
起動済み RA には新しいパスが反映されないため、FE から再起動が必要。
再起動後、ユーザーは RA メニューで `mgb-native-lcd/mgb-grain-fade.glslp`
が表示され、整数スケールで正常表示されたことを確認した。

`POKEMON GREEN.gb` と `Tetris [V1.1].gb` を同じ起動スクリプトから短時間起動。
ログに GB 設定の読込、プリセット検出、GLSL のリンク、feedback FBO 作成、
適用を確認した。旧起動スクリプトへ戻した後にも同じログを確認した。
Tetris の RetroArch GPU スクリーンショットは
`deployment/mf/mgb-mf-tetris-test.png`。向き、格子、粒子、四辺の影を確認でき、
ユーザーも実機表示を確認した。ポケモン緑の自動撮影時点は無地画面だった。
ゲーム操作中の残像の主観評価と負荷計測は MF では未実施。

## plumOS-MMF

MMF の RetroArch 1.22.2 は `sdl_dingux` 描画で、機能一覧には OpenGL、GLSL がない。
MStar フレームバッファのみを確認した。元の 3 ファイルを
`plumos/retroarch/.config/retroarch/shaders/mgb-native-lcd/` へ保管し、
SHA-256 がローカルと一致することを確認したが、画面には適用していない。

CPU 映像フィルター版の試作は `deployment/mmf/` にあり、ホストの画像生成テスト
までは通った。しかし MMF の RetroArch 実行ファイルには SoftFilter 処理自体が
含まれず、設定を読み込んでもフィルターは起動しなかった。試験用の `.cfg`、
`.filt`、`.so` は実機から除去済み。MMF の画面に適用するには、この機種用
RetroArch の再ビルド、または別の描画経路への移植が必要。
