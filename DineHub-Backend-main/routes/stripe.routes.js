const express = require('express');
const router = express.Router();
const stripe = require('stripe')('sk_test_51QrMlZG2z001wkhcJV6btPewKVA6Ehdy9dCk4cA9A1Tzrf0Vek2BBfgwdHo5EbF3huNEtla4did3QLvhha1z8K4q00BRnU5Uy0'); // Replace with your Stripe secret key

router.post('/create-checkout-session', async (req, res) => {
    // Hardcoded items
    const lineItems = [
        {
            price_data: {
                currency: 'usd',
                product_data: {
                    name: 'Product 1',
                },
                unit_amount: 2000, // Price in cents ($20.00)
            },
            quantity: 1,
        },
        {
            price_data: {
                currency: 'usd',
                product_data: {
                    name: 'Product 2',
                },
                unit_amount: 1500, // Price in cents ($15.00)
            },
            quantity: 2,
        },
    ];

    try {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            line_items: lineItems,
            mode: 'payment',
            success_url: 'https://yourdomain.com/success', // Replace with your success URL
            cancel_url: 'https://yourdomain.com/cancel', // Replace with your cancel URL
        });

        res.json({ id: session.id });
    } catch (error) {
        console.error('Error creating Stripe checkout session:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

module.exports = router;