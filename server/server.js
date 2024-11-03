import config from "./src/config/config.js";
import { server } from "./app.js";
import './src/socket.js'; 

server.listen(config.PORT, () => {
    console.log(`Listening on port ${config.PORT}`);
});