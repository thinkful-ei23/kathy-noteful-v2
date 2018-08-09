'use strict';

const express = require('express');
const knex = require('../knex');
// Create an router instance (aka "mini-app")
const router = express.Router();

//GET ALL TAGS
router.get('/', (req, res, next) => {
  knex
    .select('tags.id', 'name')
    .from('tags')
    .orderBy('tags.id')
    .then(results => {
      //console.log(results);
      res.json(results);
    })
    .catch(err => {
      next(err);
    });
});

//GET by id
router.get('/:id', (req, res, next) => {
  const { id } = req.params;

  knex
    .select('tags.id', 'name')
    .from('tags')
    .where('tags.id', id)
    .then(results => {
      //console.log(results);
      res.json(results[0]);
    })
    .catch(err => {
      next(err);
    });
});
// UPDATE folder - endpoint not used, but create to round out API

router.put('/:id', (req, res, next) => {
  const id = req.params.id;
  const { name } = req.body;
  const newItem = { name };

  //   /***** Never trust users - validate input *****/
  if (!newItem.name) {
    const err = new Error('Missing `name` in request body');
    err.status = 400;
    return next(err);
  }

  knex('tags')
    .update('name', newItem.name)
    .where('id', id)
    .returning(['id', 'name'])
    .then(results => {
      res.json(results);
    })
    .catch(err => {
      next(err);
    });
});

// CREATE / POST a tag
router.post('/', (req, res, next) => {
  const { name } = req.body;


  /***** Never trust users - validate input *****/
  if (!name) {
    const err = new Error('Missing `name` in request body');
    err.status = 400;
    return next(err);
  }
  const newItem = { name };

  knex
    .insert(newItem)
    .into('tags')
    .returning(['id', 'name'])
    .then((results) => {
      // USES array index solution to get first item in results array'
      const result = results[0];
      res.location(`${req.originalUrl}/${result.id}`).status(201).json(result);

    })
    .catch(err => {
      next(err);
    });
});
//============================================
router.delete('/:id', (req, res, next) => {
  const id = req.params.id;

  knex('tags')
    .where('tags.id', id)
    .del()
    .then( () => {
      res.sendStatus(204);
    })
    .catch(err => {
      next(err);
    });
});



module.exports = router;