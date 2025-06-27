import { InMemoryNotesRepository } from '@/repositories/in-memory/in-memory-notes-repository'
import { beforeEach, describe, expect, it } from 'vitest'
import { InMemoryUsersRepository } from '@/repositories/in-memory/in-memory-users-repository'
import type { User } from '@prisma/client'
import { DeleteNoteUseCase } from './delete-note'

let notesRepository: InMemoryNotesRepository
let usersRepository: InMemoryUsersRepository
let sut: DeleteNoteUseCase

let user: User


describe('Delete note use case tests', () => {
  beforeEach(async () => {
    notesRepository = new InMemoryNotesRepository()
    usersRepository = new InMemoryUsersRepository()
    sut = new DeleteNoteUseCase(notesRepository)

    user = await usersRepository.create({
      name: "Jonny Test",
      email: "Jonnytest@test.com",
      password_hash: "hashedpassword",
    })
    
  })

  it('should be able to delete a user note', async () => {
    await notesRepository.create({
        title: "Test note 1",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    const noteToDelete = await notesRepository.create({
        title: "Test note 2",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await notesRepository.create({
        title: "Test note 3",
        content: "testing the note creation and verify it's working",
        userId: user.id
    })

    await sut.execute({
      noteId: noteToDelete.id
    })

    const notes = notesRepository.items

    expect(notes).toHaveLength(2)
  })

})