import { makeUpdateNoteUseCase } from '@/use-cases/factories/make-update-note-use-case'
import type { FastifyReply, FastifyRequest } from 'fastify'
import { z } from 'zod'

export async function update(request: FastifyRequest, reply: FastifyReply) {
    const updateNoteParamsSchema = z.object({
        noteId: z.string().uuid(),
      })

  const updateNoteBodySchema = z.object({
    title: z.string().min(3, "O titulo deve ter no minimo 3 caracteres").max(30, "O titulo deve ter no maximo 30 caracteres").optional(),
    content: z.string().min(25, "O conteúdo deve ter no minimo 25 caracteres").max(300, "O conteúdo deve ter no maximo 300 caracteres").optional(),
  })

  const { noteId } = updateNoteParamsSchema.parse(request.params)

  const { title, content } =
  updateNoteBodySchema.parse(request.body)

  const updateNoteUseCase = makeUpdateNoteUseCase()

  await updateNoteUseCase.execute({
    noteId,
    title,
    content,
  })

  return reply.status(201).send()
}