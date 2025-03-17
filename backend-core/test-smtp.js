const nodemailer = require('nodemailer');
require('dotenv').config(); // Add this to load environment variables

async function testSMTP() {
  let transporter = nodemailer.createTransport({
    host: process.env.MAIL_HOST,
    port: parseInt(process.env.MAIL_PORT),
    secure: process.env.MAIL_SECURE === 'true',
    auth: {
      user: process.env.MAIL_USER,
      pass: process.env.MAIL_PASSWORD,
    },
  });

  try {
    let info = await transporter.sendMail({
      from: `"No Reply" <${process.env.MAIL_FROM}>`,
      to: 'achinthaekanayake7@gmail.com',
      subject: 'Test Email',
      text: 'This is a test email',
    });

    console.log('Message sent: %s', info.messageId);
  } catch (error) {
    console.error('Error sending email:', error);
  }
}

testSMTP(); 