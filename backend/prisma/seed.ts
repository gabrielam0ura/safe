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