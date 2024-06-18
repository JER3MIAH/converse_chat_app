"""User model"""


class User:
    """User class
    """

    def __init__(self, username, email, uid=None, access_token=None) -> None:
        self.uid = uid
        self.username = username
        self.email = email
        self.access_token = access_token

    def to_dict(self):
        """Converts User model to a dictionary

        Returns:
            dict: user model if dict format
        """
        return {
            'uid': self.uid,
            'username': self.username,
            'email': self.email,
            'access_token': self.access_token,
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
            uid=user_dict['uid'],
            username=user_dict['username'],
            email=user_dict['email'],
            access_token=user_dict['access_token'],
        )
