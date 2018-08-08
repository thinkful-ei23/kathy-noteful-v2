'use strict';

const knex = require('../knex');
//=============================GET by searchTerm
let searchTerm = '%cat%';
knex
  .select('notes.id', 'title', 'content')
  .from('notes')
  .modify(function (queryBuilder) {
    if (searchTerm) {
      queryBuilder.where('title', 'like', `%${searchTerm}%`);
    }
  })
  .orderBy('notes.id')
  .then(results => {
    console.log(JSON.stringify(results, null, 2));
  })
  .catch(err => {
    console.error(err);
  });

// // // //================== GET by id

// const id = 1004;
knex
  .select('notes.id', 'title', 'content')
  .from('notes')
  .where('id', id) //('notes.id')
  .then(results =>  {
    console.log(results[0]);
  })
  .catch(err => {
    console.error(err);
  });

// // // UPDATE by id
let id = 1000;

knex('notes')
  .where('id', id)
  .update('title', 'This is the new UPDATED Knex title')
  .then(results =>  {
    console.log(results[0]);
  })
  .catch(err => {
    console.error(err);
  });

//CREATE a note with prop and inserts into db and returns new note as object

knex
  .insert({title: 'NEW Inserted Title', content: 'Some more stuff'})
  .into('notes')
  .returning(['id','title','content'])
  .then(results =>  {
    console.log(results[0]);
  })
  .catch(err => {
    console.error(err);
  });


// DELETE by id
id = 1024;
knex('notes')
  .where('id', id)
  .del()
  .then(console.log);















//   if( results.length ) {
//     next();
//   }else {
//     res.json(results[0]);
// 	}
// 	.catch(err) => {
// 		next(err);
// 	}
// });
