import subprocess


def run_diagnostic(target: str) -> None:
    subprocess.run(
        ["ping", "-c", "1", target],
        check=True,
    )
