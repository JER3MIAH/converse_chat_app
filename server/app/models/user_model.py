"""User model"""


class User:
    """User class
    """

    def __init__(self, username, email, password) -> None:
        self.username = username
        self.email = email
        self.password = password

    def to_dict(self):
        """Converts User model to a dictionary

        Returns:
            dict: user model if dict format
        """
        return {
            'username': self.username,
            'email': self.email,
            'password': self.password,
        }

    @staticmethod
    def from_dict(user_dict):
        """Takes a dictionary and converts it to a User object

        Args:
            user_dict (dict): user dictionary argument

        Returns:
            user: User object
        """
        return User(
            username=user_dict['username'],
            email=user_dict['email'],
            password=user_dict['password'],
        )
