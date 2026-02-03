db = db.getSiblingDB('openedx');
db.createUser({
  user: 'openedx',
  pwd: 'CHANGEME',
  roles: [{ role: 'readWrite', db: 'openedx' }],
});
