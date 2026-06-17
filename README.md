# SIDM SQL Server Monitor

Python/wxPython rewrite of the PowerBuilder SQL Server blocking-session monitor exported under `sidm`.

## 功能

- 定时查询 SQL Server 阻塞和被阻塞会话。
- 按锁关系生成树形显示。
- 显示阻塞 SQL 文本。
- 播放 `warning.wav` 或系统提示音。
- 写入每日 `log/YYYY.MM.DD_服务器.txt` 和 `.xlsx` 日志。
- 可选按等待秒数自动执行 `KILL <spid>`。

## 环境

- Python 3.10+
- Microsoft SQL Server ODBC Driver
- Python 依赖：`wxPython`、`pyodbc`、`openpyxl`

安装依赖：

```powershell
python -m pip install -e .[dev]
```

如果 wxPython 安装较慢或失败，可以单独安装：

```powershell
python -m pip install wxPython pyodbc openpyxl pytest
```

## 配置

复制示例配置：

```powershell
Copy-Item config.example.ini config.ini
```

编辑 `config.ini`：

```ini
[database]
driver = ODBC Driver 18 for SQL Server
server = localhost
database = master
username = sa
password =

[monitor]
refresh_seconds = 10
auto_unlock = no
unlock_after_seconds = 60
log_dir = log
```

## 运行

```powershell
python -m sidm_monitor
```

如果没有安装 wxPython，命令会显示安装提示，不会启动窗口。

## 打包 exe

打包使用 Python 3.8 和 PyInstaller：

```powershell
py -3.8 -m pip install pyinstaller wxPython pyodbc openpyxl
cmd /c build_exe.bat
```

输出目录：

```text
dist\SIDMMonitor\SIDMMonitor.exe
```

`config.ini` 会复制到 exe 同目录，连接信息不嵌入 exe。发布时需要保留整个 `dist\SIDMMonitor` 文件夹，包括 `_internal` 子目录。

## 自动解锁

自动解锁会对根阻塞会话执行 `KILL <spid>`。默认关闭。只建议在确认业务允许中断连接后开启，并先用较大的等待阈值观察日志。

## 测试

```powershell
python -m pytest -v
```
