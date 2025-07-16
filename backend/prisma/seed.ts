import { PrismaClient } from '@prisma/client'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'

dayjs.extend(utc)
dayjs.extend(timezone)

const prisma = new PrismaClient()

async function main() {

  const user = await prisma.user.upsert({
    where: { email: 'default@example.com' },
    update: {},
    create: {
      name: 'SafeUser',
      email: 'safeuser@user.com',
      password_hash: "Saf3Password",
      created_at: dayjs().utc().subtract(3, 'hour').toDate()
    },
  })

  console.log('Usuário padrão criado:', user)

  const notes = await Promise.all([
    prisma.note.upsert({
      where: { id: 'note-1' },
      update: {},
      create: {
        id: 'note-1',
        title: 'Primeira Anotação',
        content: 'Esta é minha primeira anotação no app Safe.',
        createdAt: new Date('2025-07-13T10:00:00Z'),
        userId: user.id,
      },
    }),
    prisma.note.upsert({
      where: { id: 'note-2' },
      update: {},
      create: {
        id: 'note-2',
        title: 'Lista de Compras',
        content: 'Leite, pão, ovos, frutas e verduras.',
        createdAt: new Date('2024-07-15T14:30:00Z'),
        userId: user.id,
      },
    }),
    prisma.note.upsert({
      where: { id: 'note-3' },
      update: {},
      create: {
        id: 'note-3',
        title: '8 meses',
        content: 'Comemorar 8 meses de namoro (te amo milady).',
        createdAt: new Date('2025-07-16T09:15:00Z'),
        userId: user.id,
      },
    }),
    prisma.note.upsert({
      where: { id: 'note-4' },
      update: {},
      create: {
        id: 'note-4',
        title: 'Lembretes Importantes',
        content: 'Reunião às 15h, pagar contas, ligar para o médico.',
        createdAt: new Date('2025-07-17T16:45:00Z'),
        userId: user.id,
      },
    }),
  ])

  console.log('Anotações criadas:', notes.length)

}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  }) 