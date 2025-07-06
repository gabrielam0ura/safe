import { InMemoryNotesRepository } from '@/repositories/in-memory/in-memory-notes-repository'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { InMemoryUsersRepository } from '@/repositories/in-memory/in-memory-users-repository'
import type { User } from '@prisma/client'
import { SearchNotesByDateUseCase } from './search-notes-by-date'

let notesRepository: InMemoryNotesRepository
let usersRepository: InMemoryUsersRepository
let sut: SearchNotesByDateUseCase

let user: User


describe('Seacth notes by date use case tests', () => {
  beforeEach(async () => {
    notesRepository = new InMemoryNotesRepository()
    usersRepository = new InMemoryUsersRepository()
    sut = new SearchNotesByDateUseCase(notesRepository)
    vi.useFakeTimers()

    user = await usersRepository.create({
      name: "Jonny Test",
      email: "Jonnytest@test.com",
      password_hash: "hashedpassword",
    })
    
  })

  afterEach( () => {
    vi.useRealTimers()
  })

  it('should be able to search a user notes in a specific date', async () => {
    vi.setSystemTime(new Date(2024, 10, 25))
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

    vi.setSystemTime(new Date(2024, 11, 25))

    await notesRepository.create({
        title: "Test note 3",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    const { notes } = await sut.execute({
      startDate: new Date(2024, 10, 25),
      endDate: new Date(2024, 10, 25),
      userId: user.id
    })

    expect(notes[0].id).toEqual(expect.any(String))
    expect(notes).toHaveLength(2)
  })

})