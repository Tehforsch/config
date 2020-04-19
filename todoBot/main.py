import logging
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
from pathlib import Path
import yaml
import os
from pathlib import Path

# Enable logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)

logger = logging.getLogger(__name__)


def findById(objectWithId, listOfObjects, constructor):
    for obj in listOfObjects:
        if objectWithId.id == obj.id:
            return obj
    return constructor(objectWithId)


def runCommand(command):
    os.system(" ".join(command))


class EndOfDayBot:
    def parseMessage(self, bot, update):
        content = update.message.text
        self.addTask(content)
        bot.send_message(
            chat_id=update.effective_chat.id, text="{} added to inbox.".format(content)
        )

    def addTask(self, content):
        assert ("(" not in content) and (")" not in content)
        out = runCommand(
            ["emacsclient", "--eval", "'(add-task-to-inbox \"{}\")'".format(content),]
        )

    def error(self, bot, update, error):
        logger.warning('Update "%s" caused error "%s"', update, error)

    def help(self, bot, update):
        """You already know what this does."""
        content = "\n".join(
            "/{}: {}".format(name, command.__doc__) for (name, command) in self.commands
        )
        bot.send_message(chat_id=update.effective_chat.id, text=content)

    def main(self, apiTokenPath):
        with open(apiTokenPath, "r") as f:
            token = f.readlines()[0].replace("\n", "")
        updater = Updater(token)

        dispatcher = updater.dispatcher
        dispatcher.add_error_handler(self.error)
        self.commands = [
            ("help", self.help),
        ]
        for (name, command) in self.commands:
            dispatcher.add_handler(CommandHandler(name, command))
        dispatcher.add_handler(MessageHandler(Filters.all, self.parseMessage))

        updater.start_polling()
        updater.idle()


apiToken = Path(Path(__file__).parent, "apiToken")
bot = EndOfDayBot()

if __name__ == "__main__":
    bot.main(apiToken)
