import { InMemoryNotesRepository } from '@/repositories/in-memory/in-memory-notes-repository'
import { beforeEach, describe, expect, it } from 'vitest'
import { InMemoryUsersRepository } from '@/repositories/in-memory/in-memory-users-repository'
import type { User } from '@prisma/client'
import { SearchNotesUseCase } from './search-notes'

let notesRepository: InMemoryNotesRepository
let usersRepository: InMemoryUsersRepository
let sut: SearchNotesUseCase

let user: User


describe('Search notes use case tests', () => {
  beforeEach(async () => {
    notesRepository = new InMemoryNotesRepository()
    usersRepository = new InMemoryUsersRepository()
    sut = new SearchNotesUseCase(notesRepository)

    user = await usersRepository.create({
      name: "Jonny Test",
      email: "Jonnytest@test.com",
      password_hash: "hashedpassword",
    })
    
  })

  it('should be able to search a user notes by query', async () => {
    await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await notesRepository.create({
        title: "Test note 2",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await notesRepository.create({
        title: "Test note 3",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    const { notes } = await sut.execute({
      query: "3",
      userId: user.id
    })

    expect(notes[0].id).toEqual(expect.any(String))
    expect(notes).toHaveLength(1)
  })

})