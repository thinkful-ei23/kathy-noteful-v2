'use strict';

const express = require('express');
const knex = require('../knex');
// Create an router instance (aka 'mini-app')
const router = express.Router();
const hydrateNotes = require('../utils/hydrateNotes');
// TEMP: Simple In-Memory Database
//const data = require('../db/notes');
// const simDB = require('../db/simDB');
// const notes = simDB.initialize(data);

/* ========== GET/READ ALL NOTES ========== */

router.get('/', (req, res, next) => {
  const { folderId, searchTerm, tagId } = req.query;
  knex
    .select(
      'notes.id',
      'title',
      'content',
      'folder_id as folderId',
      'folders.name as foldersName',
      'tags.name as tagName',
      'tags.id as tagId'
    )
    .from('notes')
    .leftJoin('folders', 'notes.folder_id', 'folders.id')
    .leftJoin('notes_tags', 'notes_tags.note_id', 'notes.id')
    .leftJoin('tags', 'notes_tags.tag_id', 'tags.id')
    .modify(function(queryBuilder) {
      if (searchTerm) {
        queryBuilder.where('title', 'like', '`%{searchTerm}%`');
      }
    })
    .modify(function(queryBuilder) {
      if (folderId) {
        queryBuilder.where('folder_id', folderId);
      }
    })
    .modify(function(queryBuilder) {
      if (tagId) {
        queryBuilder.where('tag_id', tagId);
      }
    })
    .orderBy('notes.id')
    .then(result => {
      if (result) {
        const hydrated = hydrateNotes(result);
        res.json(hydrated);
      } else {
        next();
      }
    })
    .catch(err => next(err));
});

/* ========== GET/READ SINGLE NOTE ========== */
router.get('/:id', (req, res, next) => {
  const { id } = req.params;

  knex
    .select(
      'notes.id',
      'title',
      'content',
      'folder_id as folderId',
      'folders.name as foldersName',
      'tags.name as tagName',
      'tags.id as tagId'
    )

    .from('notes')
    .leftJoin('folders', 'notes.folder_id', 'folders.id')
    .leftJoin('notes_tags', 'notes_tags.note_id', 'notes.id')
    .leftJoin('tags', 'notes_tags.tag_id', 'tags.id')
    .where('notes.id', id)
    .then(result => {
      if (result) {
        const hydrated = hydrateNotes(result);
        res.json(hydrated);
      } else {
        next();
      }
    })
    .catch(err => {
      next(err);
    });
});

/* ========== POST/CREATE a single ITEM ========== */
router.post('/', (req, res, next) => {
  const { title, content, folderId, tags = [] } = req.body;

  /***** Never trust users. Validate input *****/
  if (!title) {
    const err = new Error('Missing `title` in request body');
    err.status = 400;
    return next(err);
  }

  const newItem = {
    title: title,
    content: content,
    folder_id: folderId ? folderId : null
  };

  let noteId;
  knex
    .insert(newItem)
    .into('notes')
    .returning('id')
    .then(([id]) => {
      noteId = id;
      const tagsInsert = tags.map(tagId => ({
        note_id: noteId,
        tag_id: tagId
      }));
      return knex.insert(tagsInsert).into('notes_tags');
    })
    .then(() => {
      return knex
        .select(
          'notes.id',
          'title',
          'content',
          'folder_id as folderId',
          'folders.name as foldersName',
          'tags.name as tagName',
          'tags.id as tagId'
        )
        .from('notes')
        .leftJoin('folders', 'notes.folder_id', 'folders.id')
        .leftJoin('notes_tags', 'notes_tags.note_id', 'notes.id')
        .leftJoin('tags', 'notes_tags.tag_id', 'tags.id')
        .where('notes.id', noteId);
    })
    .then(result => {
      if (result) {
        const hydrated = hydrateNotes(result)[0];
        res
          .location(`${req.originalUrl}/${hydrated.id}`)
          .status(201)
          .json(hydrated);
      } else {
        next();
      }
    })
    .catch(err => {
      next(err);
    });
});

/* ========== PUT/UPDATE A SINGLE ITEM ========== */
router.put('/:id', (req, res, next) => {
  const noteId = req.params.id;
  const { title, content, folderId, tags = [] } = req.body;

  /***** Never trust users. Validate input *****/
  if (!title) {
    const err = new Error('Missing `title` in request body');
    err.status = 400;
    return next(err);
  }

  const updateItem = {
    title: title,
    content: content,
    folder_id: folderId ? folderId : null
  };

  knex('notes')
    .update(updateItem)
    .where('id', noteId)
    .then(() => {
      return knex
        .del()
        .from('notes_tags')
        .where('note_id', noteId);
    })
    .then(() => {
      const tagsInsert = tags.map(tid => ({ note_id: noteId, tag_id: tid }));
      return knex.insert(tagsInsert).into('notes_tags');
    })
    .then(() => {
      return knex
        .select(
          'notes.id',
          'title',
          'content',
          'folder_id as folderId',
          'folders.name as folderName',
          'tags.id as tagId',
          'tags.name as tagName'
        )
        .from('notes')
        .leftJoin('folders', 'notes.folder_id', 'folders.id')
        .leftJoin('notes_tags', 'notes.id', 'notes_tags.note_id')
        .leftJoin('tags', 'tags.id', 'notes_tags.tag_id')
        .where('notes.id', noteId);
    })
    .then(result => {
      if (result) {
        const [hydrated] = hydrateNotes(result);
        res.json(hydrated);
      } else {
        next();
      }
    })
    .catch(err => {
      next(err);
    });
});

/* ========== DELETE/REMOVE A SINGLE ITEM ========== */

router.delete('/:id', (req, res, next) => {
  const id = req.params.id;

  knex('notes')
    .where('notes.id', id)
    .del()
    .then(results => {
      res.json(results);
    })
    .catch(err => {
      next(err);
    });
});

module.exports = router;
