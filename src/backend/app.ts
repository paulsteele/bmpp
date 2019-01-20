import * as express from 'express';

const server = express();

server.use('/', express.static('dist'));
server.use('/backend', (req, res) => {
  res.send(404);
});

server.listen('8080');
console.log('Bull Moose Party Podcast - Started');