from sidm_monitor.app import app_icon_path


def test_app_icon_path_exists_in_source_tree() -> None:
    assert app_icon_path().name == "red_skull_icon.ico"
    assert app_icon_path().exists()
