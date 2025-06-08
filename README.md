# setup-ohos

A simple action to download and setup HarmonyOS NEXT (API12+) building environment in GitHub Action

- latest CLI tools version: `5.0.13.200`
- latest SDK version: `5.0.5.165`
- latest API: `5.0.5(17)`

## Dependencies

- `cURL` - Download sdk
- `libGL1` - [Texture compression](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-command-line-building-app#section1478651816216)
- `jq` - JSON processer, already embedded in GitHub Action

```yaml
- name: Install dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y curl libgl1-mesa-dev
  shell: bash
```

## Usage

```yaml
steps:
  - name: Clone repository
    uses: actions/checkout@v4
  - name: Setup HarmonyOS CLI tools
    uses: ErBWs/setup-ohos@v1
    with:
      version: latest
      cache: true
  - run: hvigorw -v
```

> [!IMPORTANT]
>
> If you are using `latest` as version with cache on, you need to clear your action's cache when you want to upgrade the SDK

### Options

| Name      | Description                                               |
| --------- | --------------------------------------------------------- |
| version   | Verison of CLI tools, can be `latest`, `5.0.13.200`, etc. |
| cache     | Whether to cache the SDK, can be `true` or `false`        |

### Environment variables

For now only `HOS_SDK_HOME` is exported for flutter. If more envs are needed, feel free to file an issue and I will add it

| Name                    | Value                                          |
| ----------------------- | ---------------------------------------------- |
| HOS_SDK_HOME            | /home/runner/ohos-sdk/command-line-tools/sdk   |

### Supported version

Check out [ErBWs / ohos-sdk](https://github.com/ErBWs/ohos-sdk/releases) for more supported version codes
