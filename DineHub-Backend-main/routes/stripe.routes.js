const express = require('express');
const router = express.Router();
const stripe = require('stripe')('sk_test_51QrMlZG2z001wkhcJV6btPewKVA6Ehdy9dCk4cA9A1Tzrf0Vek2BBfgwdHo5EbF3huNEtla4did3QLvhha1z8K4q00BRnU5Uy0'); // Replace with your Stripe secret key

router.post('/create-checkout-session', async (req, res) => {
    const { items } = req.body;

    const lineItems = items.map(item => ({
        price_data: {
            currency: 'pkr',
            product_data: {
                name: item.name,
            },
            unit_amount: item.price * 100, // Convert to cents
        },
        quantity: item.quantity,
    }));

    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: lineItems.reduce((total, item) => total + item.price_data.unit_amount * item.quantity, 0),
            currency: 'pkr',
            payment_method_types: ['card'],
        });

        res.json({ client_secret: paymentIntent.client_secret });
    } catch (error) {
        console.error('Error creating Stripe payment intent:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

module.exports = router;