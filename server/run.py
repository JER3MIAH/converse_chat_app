"""Todo CRUD Api"""

from app.routes import auth_routes
from app.config.config import app

# register blueprints
app.register_blueprint(auth_routes.auth_bp)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
