import { makeDeleteNoteUseCase } from '@/use-cases/factories/make-delete-note-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'

export async function deleteNote(
  request: FastifyRequest,
  reply: FastifyReply,
) {
    const updateNoteParamsSchema = z.object({
        noteId: z.string().uuid(),
      })

    const { noteId } = updateNoteParamsSchema.parse(request.params)

    const deleteNoteUseCase = makeDeleteNoteUseCase()

    await deleteNoteUseCase.execute({
      noteId,
    })

    return reply.status(204).send()
  
}