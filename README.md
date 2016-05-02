# Fluent::Mixin::KvsConfig

Fluent::Mixin::KvsConfig provides '$KVS{kvs-key}' placeholder to fluentd plug-ins that include this mix-in. Placeholder will be expanded to the value of the KVS in the 'super' of plug-ins #configure method that you include.

## Usage

In KVS

| key | value |
+-----+-------+
| KVSCONF_KEY1 | VALUE_KEY1 |
| KVSCONF_KEY2 | VALUE_KEY2 |

In plugin (both of input and output), just include mixin.

    class FooInput < Fluent::Input
      Fluent::Plugin.register_input('foo', self)
    
      config_param :tag, :string
      
      include Fluent::Mixin::KvsConfig
    
      def configure(conf)
        super # MUST call 'super' at first!
        
        @tag #=> here, you can get string replaced '$KVS{KVSCONF_KEY1}' into 'VALUE_KEY1'
      end
      
      # ...
    end

By using this feature, you can change the settings without having to modify the configuration file at the time of plug-in initialization.

### Mix-in setting

This mix-in will receive some of the parameters.

* kvs_driver - at the moment only "redis"
* kvs_host - KVS server host (default: localhost)
* kvs_port - KVS server port (default: 6379)
* kvs_db - redis database number (default: 0)
* kvs_prefix - KVS key prefix (default: 'KVSCONF_')

## IMPORTANT

Deployment of the placeholder is done at configure rather than at the reference. It is to reflect the changed value requires a restart of fluentd.

## AUTHORS

* Takashi Ikeda <im.ikeda@gmail.com>

## LICENSE

* Copyright: Copyright (c) 2016- im-ikeda
* License: Apache License, Version 2.0

-----
[Japanese]

# Fluent::Mixin::KvsConfig

Fluent::Mixin::KvsConfigは，このMix-inをインクルードしたFluentdプラグインに'$KVS{kvs-key}'プレースホルダを提供します．
プレースホルダはプラグインの #configure メソッドの `super` 内で，KVSの該当する値に展開されます．

## 使用方法

KVS内のデータ

| key | value |
+-----+-------+
| KVSCONF_KEY1 | VALUE_KEY1 |
| KVSCONF_KEY2 | VALUE_KEY2 |

プラグイン内(Input・Output共に)で，このようにインクルードしてください．

    class FooInput < Fluent::Input
      Fluent::Plugin.register_input('foo', self)
    
      config_param :tag, :string
      
      include Fluent::Mixin::KvsConfig
    
      def configure(conf)
        super # 必ず 'super' を最初に呼び出してください!!
        
        @tag #=> ここで置換された値を使うことができます(例：$KVS{KVCONF_KEY1} => 'VALUE_KEY1'
      end
      
      # ...
    end

この機能を使うことで，設定ファイルを変更することなく内容を変更することができます．

### Mix-in setting

このMix-inは下記のパラメータを受け取ります.

* kvs_driver - 現時点では "redis" のみ
* kvs_host - KVS サーバホスト(default: localhost)
* kvs_port - KVS サーバポート(default: 6379)
* kvs_db - redis database number (default: 0)
* kvs_prefix - KVS キープレフィクス(default: 'KVSCONF_')

## 重要

プレースホルダの展開は参照時ではなく#configure時に行われます．変更した値の反映にはfluentdの再起動が必要です．

## 作成者

* Takashi Ikeda <im.ikeda@gmail.com>

## ライセンス

* Copyright: Copyright (c) 2016- im-ikeda
* License: Apache License, Version 2.0

## 最後に
英文はGoogleTranslaterに全力でお世話になっておりますm(_ _)m

