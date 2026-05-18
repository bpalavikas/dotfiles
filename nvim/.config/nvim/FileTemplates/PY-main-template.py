###############################################################################
#
###############################################################################
'''!@package docstring
@file
@brief
@version
@date
@author
@copyright (C) COPYRIGHT 2023 bvrFirmware
@attention

'''
###############################################################################
#    PEP 8 Style Guide   https://peps.python.org/pep-0008/#introduction       #
###############################################################################

###############################################################################
#                               IMPORTS                                       #
###############################################################################
import logging




###############################################################################

def setup_logging() -> None:
    """Configure logging for the application."""
    logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
    )


###############################################################################
"""Main script for running the CTI Python application."""



def main() -> int:
    """Main entry point of the program."""
    setup_logging()
    logging.info("CTI Python App started.")

    try:
        config = load_config()
        run_app(config)
        logging.info("CTI Python App finished successfully.")
        return 0
    except Exception as e:
        logging.exception("An error occurred: %s", str(e))
        return 1


if __name__ == "__main__":
    sys.exit(main())




###############################################################################
#                                                                             #
###############################################################################
"""END OF FILE"""
