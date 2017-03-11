# PYNQ-Z1 フレームバッファ

## 概要
base overlayを使っているPYNQ-Z1ボード用のフレームバッファドライバモジュールです。

X Window Systemといったようなグラフィックをフレームバッファデバイスに出力するアプリケーションをPYNQ-Z1ボードで使えるようになります。

## 必要要件
* PYNQ-Z1 board もしくは同等のもの.
* PYNQ-Z1 ビルド済みイメージ (2017年2月以降にリリースされたもの).
* ARM向けのLinuxカーネルをコンパイルできる環境
    * PYNQ-Z1ボードでもLinuxカーネルをビルドできるが結構時間がかかる。
    
* Device tree コンパイラ (dtc) コマンド
    * Ubuntuを使っているなら[`device-tree-compiler`](https://launchpad.net/ubuntu/+source/device-tree-compiler)パッケージをインストールすると入る
    
        ```
        sudo apt-get install device-tree-compiler
        ```

* 下のリストにある解像度で表示できるHDMI接続ディスプレイ:
    * 640x480 @ 60Hz
    * 800x480 @ 60Hz
    * 800x600 @ 60Hz
    * 1280x720 @ 60Hz
    * 1280x1024 @ 60Hz
    * 1920x1080 @ 60Hz
    * ほかの解像度はそのうちサポートします。

## インストール
1. このリポジトリをどこかにcloneする。
    
    ```
    git clone https://github.com/ciniml/pynqz1fb
    ```

2. LinuxカーネルソースをGitHubにあるXilinxのLinuxカーネルソースリポジトリからダウンロードする。 
    
    ```
    wget https://github.com/Xilinx/linux-xlnx/archive/xilinx-v2016.4-sdsoc.tar.gz
    tar zxf xilinx-v2016.4-sdsoc.tar.gz
    ```

3. `make`をカーネルソースのパスを指定して、`pynqz1fb`ワーキングツリーのトップディレクトリで実行する
    
    ```
    cd pynqz1fb
    KERNEL_SRC_ROOT=`pwd`/../linux-xlnx-v2016.4-sdsoc make all -j8
    ```

4. 数分後に`pynqz1fb.ko`が`pynqz1fb`ディレクトリにできる。

5. device treeファイル`pynqz1.dts`を必要に応じて変更する。
    * 画面の幅と高さを含む設定はdevice treeに入っている。
    * [`width`](https://github.com/ciniml/pynqz1fb/blob/master/pynqz1.dts#L452)と[`height`](https://github.com/ciniml/pynqz1fb/blob/master/pynqz1.dts#L454)フィールドを使いたいディスプレイの解像度に合わせて変更する。
    * 標準では800x480のディスプレイ用になっている。（私のHDMIディスプレイが800x480なので)
6. 変更したdevice treeソース (\*.dts)をDevice treeバイナリ(\*.dtb)フォーマットにコンパイルする。
    ```
    dtc -I dts -O dtb -o devicetree.dtb pynqz1.dts
    ```

7. `devicetree.dtb`をSDカードのブートパーティションにコピーする。
    * 元の`devicetree.dtb`をどこかにバックアップしておくように気を付ける。

8. PYNQ-Z1ボードの電源を入れ、HDMIディスプレイをHDMI outポートに接続する。
9. `pynqz1fb.ko`をPYNQ-Z1ボードにJupyter notebookでコピーする。
10. Jupyter notebookでターミナルを開く。
11. Jupyter notebookのルートディレクトリに移動する。
    ```
    cd /home/xilinx/jupiter-notebook
    ```
12. `insmod`コマンドでカーネルモジュールを読み込む。
    ```
    insmod ./pynqz1fb.ko
    ```
13. ここまでで、HDMIディスプレイにプロンプトが表示されているはずである。
14. 何も表示されなければ、device treeのパラメータがあっているか確認する。
    * `width`や`height`パラメータは合っているか？

## ライセンス
Linuxカーネルソースと同じバージョンのGPL。(`simplefb.c`をベースにしているので。)


