import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget
from PyQt5.QtCore import QFile
from PyQt5.QtUiTools import QUiLoader

class MyWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        
        # Load the UI file
        ui_file = QFile("main.ui")
        ui_file.open(QFile.ReadOnly)
        loader = QUiLoader()
        self.ui = loader.load(ui_file, self)
        ui_file.close()
        
        # Add the UI widget to the main window
        self.setCentralWidget(self.ui)

if __name__ == "__main__":
    # Create the application
    app = QApplication(sys.argv)

    # Create the main window
    window = MyWindow()
    window.show()

    # Run the event loop
    sys.exit(app.exec_())

