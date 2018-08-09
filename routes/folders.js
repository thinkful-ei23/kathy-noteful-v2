'use strict';

const knex = require('../knex');
const express = require('express');

const router = express.Router();

//GET ALL FOLDERS
router.get('/', (req, res, next) => {
  knex
    .select('folders.id', 'name')
    .from('folders')
    .orderBy('folders.id')
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
    .select('folders.id', 'name')
    .from('folders')
    .where('folders.id', id)
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

  knex( 'folders' )
    .update( 'name', newItem.name )
    .where('id', id)
    .returning(['id', 'name'])
    .then(results => {
      res.json(results);
    })
    .catch(err => {
      next(err);
    });
});

// CREATE a folder accepts an obj with name and insert into db, returns new item and new id
router.post('/', (req, res, next) => {
  const { name } = req.body;

  const newItem = { name };
  /***** Never trust users - validate input *****/
  if (!newItem.name) {
    const err = new Error('Missing `name` in request body');
    err.status = 400;
    return next(err);
  }

  knex
    .insert({name: newItem.name })
    .into('folders')
    .returning(['id','name'])
    .then(results =>  {
      res.json(results[0]);
    })
    .catch(err => {
      next(err);
    });
});

router.delete('/:id', (req, res, next) => {
  const id = req.params.id;

  knex('folders')
    .where('id', id)
    .del()
    .then( () => res.sendStatus(204))
    .catch(err => {
      next(err);
    });
});





module.exports = router;