import subprocess


def run_diagnostic(target: str) -> None:
    command = f"ping -c 1 {target}"

    subprocess.run(
        command,
        shell=True,
        check=True,
    )
