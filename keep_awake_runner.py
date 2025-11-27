import ctypes
import subprocess
import sys

# --- Windows power management flags ---
ES_CONTINUOUS       = 0x80000000
ES_SYSTEM_REQUIRED  = 0x00000001
ES_DISPLAY_REQUIRED = 0x00000002  # include this if you also want to keep the screen on


def forhindra_vila(behall_skarmen_vaken: bool = False) -> None:
    """
    Förhindrar att Windows går i viloläge under programmets körning.
    Om behall_skarmen_vaken=True hålls även skärmen tänd.
    """
    flags = ES_CONTINUOUS | ES_SYSTEM_REQUIRED
    if behall_skarmen_vaken:
        flags |= ES_DISPLAY_REQUIRED

    ctypes.windll.kernel32.SetThreadExecutionState(flags)


def aterstall_standard_beteende() -> None:
    """
    Återställer Windows standardbeteende för viloläge.
    """
    ctypes.windll.kernel32.SetThreadExecutionState(ES_CONTINUOUS)


def huvud():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python keep_awake_runner.py <command> [args...]")
        print()
        print("Examples:")
        print('  python keep_awake_runner.py wsl bash -lc "cd /projekt && docker compose up"')
        print('  python keep_awake_runner.py python long_running_script.py')
        sys.exit(1)

    # Kommandot som ska köras (allt efter script-namnet)
    kommando = sys.argv[1:]

    # Ändra till True om ni även vill förhindra att skärmen släcks
    behall_skarmen_vaken = False

    print("Keeping Windows awake while command runs:")
    print(" ", " ".join(kommando))
    forhindra_vila(behall_skarmen_vaken=behall_skarmen_vaken)

    try:
        resultat = subprocess.run(kommando)
        exitkod = resultat.returncode
    except KeyboardInterrupt:
        # Ctrl+C ska bubbla upp så att användaren kan avbryta
        exitkod = 130  # konventionell exitkod för Ctrl+C
    finally:
        aterstall_standard_beteende()
        print("Command finished. Windows sleep behavior restored.")

    sys.exit(exitkod)


if __name__ == "__main__":
    huvud()
