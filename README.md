# setup-ohos

A simple action to download and setup HarmonyOS NEXT (API12+) building environment in GitHub Action

- latest CLI tools version: `6.1.1.280`
- latest SDK version: `6.1.1.125`
- latest API: `6.1.1(24)`

> [!IMPORTANT]
>
> For macOS and Windows, use `ErBWs/setup-ohos@v2` with CLI tools version later than `6.1.1.280`.

## Dependencies

- `libGL1` - [Texture compression](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-command-line-building-app#section1478651816216) (Linux only)
- `jq` - JSON processor, already embedded in GitHub Action

```yaml
- name: Install dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y libgl1-mesa-dev
  shell: bash
```

## Usage

```yaml
steps:
  - name: Clone repository
    uses: actions/checkout@v4
  - name: Setup HarmonyOS CLI tools
    uses: ErBWs/setup-ohos@v2
    with:
      version: 6.1.1.280
      cache: true
  - run: hvigorw -v
```

> [!IMPORTANT]
>
> If you leave `version` blank with cache on, you need to clear your action's cache when you want to upgrade the SDK.

### Options

| Name    | Description                                                                                    |
|---------|------------------------------------------------------------------------------------------------|
| version | Verison of CLI tools, can be `6.1.1.280`, etc. Optional, leave it blank to use latest version. |
| cache   | Whether to cache the SDK, can be `true` or `false`. Optional.                                  |

### Environment variables

If more envs are needed, feel free to file an issue and I will add it.

| Name          | Value                                                            |
|---------------|------------------------------------------------------------------|
| HOS_SDK_HOME  | /home/runner/ohos-sdk/command-line-tools/sdk                     |
| OHOS_NDK_HOME | /home/runner/ohos-sdk/command-line-tools/sdk/default/openharmony |

### Supported version

Check out [ErBWs / ohos-sdk](https://github.com/ErBWs/ohos-sdk/releases) for more supported version codes
