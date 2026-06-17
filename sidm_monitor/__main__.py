def main() -> None:
    from sidm_monitor.app import run_app

    try:
        run_app()
    except RuntimeError as exc:
        print(exc)


if __name__ == "__main__":
    main()
